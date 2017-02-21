## Git Extensions

### Update

Updates target branch from origin, then rebase current branch onto it. 

Usage:
```
git update <branch>
```

Examples:
```
git update develop
```

### Squash

Interactive rebase with autosquash to the specified commit. 

Usage:
```
git squash <commit>
```

Examples:
```
git squash 1
git squash HEAD^
git squash 541afa9e
```