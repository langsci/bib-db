import shutil
import os
import urllib.request
from urllib.error import URLError, HTTPError
import glob

# create a designated folder named Bibliography in the cwd
if not os.path.exists('Bibliography'):
    os.makedirs('Bibliography')
urlhead = 'https://raw.githubusercontent.com/langsci/'
urltail = '/master/localbibliography.bib'
dir = os.path.abspath('./Bibliography/')
for i in range(1,350):
    url0 = urlhead + str(i) + urltail
    try:
        a = urllib.request.urlopen(url0)
    except URLError as HTTPError:
        print('.', end='')
    else:
        cf = os.path.join(dir,'lb' + str(i) + '.bib')
        urllib.request.urlretrieve(url0, cf)
print('Done.')

# create a list of all files in the directory ./Bibliography
lblist = glob.glob('./Bibliography/*')
with open('coll.bib','wb') as wfd:
    for f in lblist:
        with open(f,'rb') as fd:
            shutil.copyfileobj(fd,wfd)
            wfd.write(b"\n")
