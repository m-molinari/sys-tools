# Python environment

**Create env**	<br/>
```
python -m venv NAME
```


**Activate env**	<br/>
```
source bin/activate
```

**Save modules** <br/>
```
pip freeze > requirements.txt
```

**Deactivate env** <br/>
```
deactivate
```
# Python pydoc
**Find documentation about module**
```
python -m pydoc math
```

**Find documentation by name**
```
python -m pydoc -k sql
```

**Launch doc as service browser**
```
sudo pydoc3  -p PORT
```
and browse it by http://localhost:PORT



