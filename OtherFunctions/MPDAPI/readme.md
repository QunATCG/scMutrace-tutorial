
`MPD_API.py` - Batch download SNP/indel data from the Mouse Phenome Database (MPD) API

https://phenome.jax.org/about/api

![MPG](./MPG.png)

**Requirements**

- Python 3.x
- `requests` library
- `pandas` library

Install dependencies with:

```bash
pip install requests pandas
```

**Run with**

Replace the region files in `MPD_API.py` with your own BED files, which were extracted from the output of scMutrace.

![regions](./regions_input_codes.png)


```bash
python MPD_API.py
```