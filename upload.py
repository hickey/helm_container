#!/usr/bin/env python

import os, sys
import pprint
from cgi import parse_qs, escape, FieldStorage
from stat import *


def application(env, start_response):
    status_code = "500 ERROR"
    output = ["Chart upload request received"]

    # descerialize the post
    post = FieldStorage(
                    fp=env['wsgi.input'],
                    environ=env,
                    keep_blank_values=True
                )
    chart_name = post['file'].filename
    upload_fp = post['file'].file

    try:
        # attempt to save the chart to  the top of html
        with open("/web/html/%s" % chart_name, "w") as chart_fp:
            chart_fp.write(upload_fp.read())
    except Exception as e:
        output.append("Exception received while writing chart file: %s" % chart_name)
        output.append("%s" % e)
    else:
        output.append("Wrote %d to %s" % (os.stat("/web/html/%s" % chart_name).st_size,
                                          chart_name))
    
    # Reindex the chart repository
    try:
        os.system("/usr/local/bin/helm repo index /web/html")
    except Exception as e:
        output.append("Exception received while generating index.")
        output.append("%s" % e)
    else:
        output.append("Reindexed repo")
        status_code = "200 OK"

    response_text = "\n".join(output) + "\n\n"

    start_response(status_code, 
                   [('Content-Type', 'text/plain'),
                    ('Content-Length', str(len(response_text)))])
    return response_text

