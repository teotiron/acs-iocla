#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_LINE_SIZE 300

struct Dir;
struct File;

typedef struct Dir{
	char *name;
	struct Dir* parent;
	struct File* head_children_files;
	struct Dir* head_children_dirs;
	struct Dir* next;
} Dir;

typedef struct File {
	char *name;
	struct Dir* parent;
	struct File* next;
} File;

void stop (Dir* target);

void touch (Dir* parent, char* name) {
	File* iterator = parent->head_children_files;
	while (iterator != NULL) {
		if (strcmp(iterator->name, name) == 0) {
			printf("File already exists\n");
			return;
		}
		iterator = iterator->next;
	}
	File* newfile = malloc(sizeof(File));
	newfile->name = malloc(strlen(name) + 1);
	strcpy(newfile->name, name);
	newfile->parent = parent;
	newfile->next = NULL;
	if (parent->head_children_files == NULL) {
		parent->head_children_files = newfile;
	} else {
		iterator = parent->head_children_files;
		while (iterator->next != NULL) {
			iterator = iterator->next;
		}
		iterator->next = newfile;
	}
}

void mkdir (Dir* parent, char* name) {
	Dir* iterator = parent->head_children_dirs;
	while (iterator != NULL) {
		if (strcmp(iterator->name, name) == 0) {
			printf("Directory already exists\n");
			return;
		}
		iterator = iterator->next;
	}
	Dir* newdir = malloc(sizeof(Dir));
	newdir->name = malloc(strlen(name) + 1);
	strcpy(newdir->name, name);
	newdir->parent = parent;
	newdir->head_children_files = NULL;
	newdir->head_children_dirs = NULL;
	newdir->next = NULL;
	if (parent->head_children_dirs == NULL) {
		parent->head_children_dirs = newdir;
	} else {
		iterator = parent->head_children_dirs;
		while (iterator->next != NULL) {
			iterator = iterator->next;
		}
		iterator->next = newdir;
	}
}

void ls (Dir* parent) {
	Dir* dir_it = parent->head_children_dirs;
	while (dir_it != NULL) {
		printf("%s\n", dir_it->name);
		dir_it = dir_it->next;
	}
	File* file_it = parent->head_children_files;
	while (file_it != NULL) {
		printf("%s\n", file_it->name);
		file_it = file_it->next;
	}

}

void rm (Dir* parent, char* name) {
	if (parent->head_children_files == NULL) {
		printf("Could not find the file\n");
		return;
	}
	if (strcmp(parent->head_children_files->name, name) == 0) {
		File* second = parent->head_children_files->next;
		free(parent->head_children_files->name);
		free(parent->head_children_files);
		parent->head_children_files = second;
		return;
	} else {
		File* iterator = parent->head_children_files->next;
		File* aux = parent->head_children_files;
		while (iterator != NULL) {
			if (strcmp(iterator->name, name) == 0) {
				aux->next = iterator->next;
				free(iterator->name);
				free(iterator);
				return;
			}
			iterator = iterator->next;
			aux = aux->next;
		}
	}
	printf("Could not find the file\n");
}

void rmdir (Dir* parent, char* name) {
	if (parent->head_children_dirs == NULL) {
		printf("Could not find the dir\n");
		return;
	}
	if (strcmp(parent->head_children_dirs->name, name) == 0) {
		Dir* second = parent->head_children_dirs->next;
		free(parent->head_children_dirs->name);
		stop(parent->head_children_dirs);
		free(parent->head_children_dirs);
		parent->head_children_dirs = second;
		return;
	} else {
		Dir* iterator = parent->head_children_dirs->next;
		Dir* aux = parent->head_children_dirs;
		while (iterator != NULL) {
			if (strcmp(iterator->name, name) == 0) {
				aux->next = iterator->next;
				free(iterator->name);
				stop(iterator);
				free(iterator);
				return;
			}
			iterator = iterator->next;
			aux = aux->next;
		}
	}
	printf("Could not find the dir\n");
}

void cd(Dir** target, char *name) {
	if (strcmp("..", name) == 0) {
		if ((*target)->parent != NULL)
			*target = (*target)->parent;
		return;
	}
	Dir* iterator = (*target)->head_children_dirs;
	while (iterator != NULL) {
		if (strcmp(iterator->name, name) == 0) {
			(*target) = iterator;
			return;
		}
		iterator = iterator->next;
	}
	printf("No directories found!\n");

}

char* pwd (Dir* target) {
	char* path = malloc(MAX_INPUT_LINE_SIZE);
	strcpy(path, "");
	char* aux = malloc(MAX_INPUT_LINE_SIZE);
	Dir* curr = target;
	while (curr->parent != NULL) {
		strcpy(aux, "/");
		strcat(aux, curr->name);
		strcat(aux, path);
		strcpy(path, aux);
		curr = curr->parent;
	}
	strcpy(aux, "/");
	strcat(aux, curr->name);
	strcat(aux, path);
	strcpy(path, aux);
	free(aux);
	return path;
}

void stop (Dir* target) {
	Dir* tbd_dir = target->head_children_dirs;
	Dir* aux_dir;
	while (tbd_dir != NULL) {
		aux_dir = tbd_dir->next;
		free(tbd_dir->name);
		stop(tbd_dir);
		free(tbd_dir);
		tbd_dir = aux_dir;
	}
	File* tbd_file = target->head_children_files;
	File* aux_file;
	while (tbd_file != NULL) {
		aux_file = tbd_file->next;
		free(tbd_file->name);
		free(tbd_file);
		tbd_file = aux_file;
	}
}

void tree (Dir* target, int level) {
	Dir* dir_it = target->head_children_dirs;
	while (dir_it != NULL) {
		for (int i = 0; i < level * 4; i++) {
			printf(" ");
		}
		printf("%s\n", dir_it->name);
		tree(dir_it, level + 1);
		dir_it = dir_it->next;
	}
	File* file_it = target->head_children_files;
	while (file_it != NULL) {
		for (int i = 0; i < level * 4; i++) {
			printf(" ");
		}
		printf("%s\n", file_it->name);
		file_it = file_it->next;
	}
}

void mv(Dir* parent, char *oldname, char *newname) {
	int file_exists = 0;
	int is_dir = 0;
	int is_file = 0;
	if (parent->head_children_dirs != NULL) {
		Dir* iterator = parent->head_children_dirs;
		while (iterator != NULL) {
			if (strcmp(iterator->name, oldname) == 0) {
				is_dir = 1;
			}
			if (strcmp(iterator->name, newname) == 0) {
				file_exists = 1;
			}
			iterator = iterator->next;
		}
	}
	if (parent->head_children_files != NULL) {
		File* iterator = parent->head_children_files;
		while (iterator != NULL) {
			if (strcmp(iterator->name, oldname) == 0) {
				is_file = 1;
			}
			if (strcmp(iterator->name, newname) == 0) {
				file_exists = 1;
			}
			iterator = iterator->next;
		}
	}
	if (is_dir == 0 && is_file == 0) {
		printf("File/Director not found\n");
		return;
	}
	if (file_exists == 1) {
		printf("File/Director already exists\n");
		return;
	}

	if (is_dir == 1) {
		if (strcmp(parent->head_children_dirs->name, oldname) == 0) {
			Dir* second = parent->head_children_dirs->next;
			Dir* tbm = parent->head_children_dirs;
			parent->head_children_dirs = second;
			if (parent->head_children_dirs == NULL) {
				parent->head_children_dirs = tbm;
			} else {
				Dir* iterator = parent->head_children_dirs;
				while (iterator->next != NULL) {
					iterator = iterator->next;
				}
				iterator->next = tbm;
			}
			tbm->next = NULL;
			free(tbm->name);
			tbm->name = malloc(strlen(newname) + 1);
			strcpy(tbm->name, newname);
			return;
		} else {
			Dir* iterator = parent->head_children_dirs->next;
			Dir* aux = parent->head_children_dirs;
			while (iterator != NULL) {
				if (strcmp(iterator->name, oldname) == 0) {
					aux->next = iterator->next;
					Dir* tbm = iterator;
					Dir* it2 = parent->head_children_dirs;
					while (it2->next != NULL) {
						it2 = it2->next;
					}
					it2->next = tbm;
					tbm->next = NULL;
					free(tbm->name);
					tbm->name = malloc(strlen(newname) + 1);
					strcpy(tbm->name, newname);
					return;
				}
				iterator = iterator->next;
				aux = aux->next;
			}
		}
	} else if (is_file == 1) {
		if (strcmp(parent->head_children_files->name, oldname) == 0) {
			File* second = parent->head_children_files->next;
			File* tbm = parent->head_children_files;
			parent->head_children_files = second;
			if (parent->head_children_files == NULL) {
				parent->head_children_files = tbm;
			} else {
				File* iterator = parent->head_children_files;
				while (iterator->next != NULL) {
					iterator = iterator->next;
				}
				iterator->next = tbm;
			}
			tbm->next = NULL;
			free(tbm->name);
			tbm->name = malloc(strlen(newname) + 1);
			strcpy(tbm->name, newname);
			return;
		} else {
			File* iterator = parent->head_children_files->next;
			File* aux = parent->head_children_files;
			while (iterator != NULL) {
				if (strcmp(iterator->name, oldname) == 0) {
					aux->next = iterator->next;
					File* tbm = iterator;
					File* it2 = parent->head_children_files;
					while (it2->next != NULL) {
						it2 = it2->next;
					}
					it2->next = tbm;
					tbm->next = NULL;
					free(tbm->name);
					tbm->name = malloc(strlen(newname) + 1);
					strcpy(tbm->name, newname);
					return;
				}
				iterator = iterator->next;
				aux = aux->next;
			}
		}
	}
}

int main () {
	Dir* home = malloc(sizeof(Dir));
	home->name = malloc(5);
	strcpy(home->name, "home");
	home->parent = NULL;
	home->head_children_files = NULL;
	home->head_children_files = NULL;
	home->next = NULL;
	char* cmd = malloc(MAX_INPUT_LINE_SIZE);
	Dir* curr = home;
	do
	{
		fgets(cmd, MAX_INPUT_LINE_SIZE, stdin);
		if (cmd[strlen(cmd) - 1] == '\n')
			cmd[strlen(cmd) - 1] = '\0';
		char* token;
		token = strtok(cmd, " ");
		if (strcmp(token, "touch") == 0) {
			token = strtok(NULL, " ");
			char* name = malloc(MAX_INPUT_LINE_SIZE);
			strcpy(name, token);
			touch(curr, name);
			free(name);
			continue;
		}
		if (strcmp(token, "mkdir") == 0) {
			token = strtok(NULL, " ");
			char* name = malloc(MAX_INPUT_LINE_SIZE);
			strcpy(name, token);
			mkdir(curr, name);
			free(name);
			continue;
		}
		if (strcmp(token, "ls") == 0) {
			ls(curr);
			continue;
		}
		if (strcmp(token, "rm") == 0) {
			token = strtok(NULL, " ");
			char* name = malloc(MAX_INPUT_LINE_SIZE);
			strcpy(name, token);
			rm(curr, name);
			free(name);
			continue;
		}
		if (strcmp(token, "rmdir") == 0) {
			token = strtok(NULL, " ");
			char* name = malloc(MAX_INPUT_LINE_SIZE);
			strcpy(name, token);
			rmdir(curr, name);
			free(name);
			continue;
		}
		if (strcmp(token, "cd") == 0) {
			token = strtok(NULL, " ");
			char* name = malloc(MAX_INPUT_LINE_SIZE);
			strcpy(name, token);
			cd(&curr, name);
			free(name);
			continue;
		}
		if (strcmp(token, "tree") == 0) {
			tree(curr, 0);
			continue;
		}
		if (strcmp(token, "pwd") == 0) {
			char* path = pwd(curr);
			printf("%s\n", path);
			free(path);
			continue;
		}
		if (strcmp(token, "mv") == 0) {
			token = strtok(NULL, " ");
			char* oldname = malloc(MAX_INPUT_LINE_SIZE);
			strcpy(oldname, token);
			token = strtok(NULL, " ");
			char* newname = malloc(MAX_INPUT_LINE_SIZE);
			strcpy(newname, token);
			mv(curr, oldname, newname);
			free(oldname);
			free(newname);
			continue;
		}
		if (strcmp(token, "stop") == 0) {
			stop(home);
			free(home->name);
			free(home);
			free(cmd);
			break;
		}
	} while (1);
	
	return 0;
}
