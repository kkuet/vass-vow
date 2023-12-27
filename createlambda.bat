zip -FS lambda_function.zip store.py
cd myenv/lib/python3.10/site-packages
zip -FS -r lambda_files.zip ../../../../lambda_files.py ../../../../*.so* ./*
mv -f lambda_files.zip ../../../..
cd ../../../..
