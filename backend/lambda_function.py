import random

def main(event, context):
    random_number = random.randint(0, 100) 
    return_string = 'Random number: ' + str(random_number)

    print(return_string)

    return {
        'statusCode': 200,
        'headers': {
          'Access-Control-Allow-Origin' : '*',
          'Access-Control-Allow-Credentials' : True
        },
        'body': return_string
    }

