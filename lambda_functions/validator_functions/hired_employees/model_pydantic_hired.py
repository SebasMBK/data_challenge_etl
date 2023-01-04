from pydantic import BaseModel, validator
import datetime

# In this file, lies the code for the data validation to ensure the righ quality before the ingestion.

class hired_employees(BaseModel):
    """
    Pydantic model to validate the data.
    """
    id: int
    name: str
    datetime_: str # This will be converted to datetime with the validator
    department_id: int
    job_id: int


    @validator('datetime_')
    def datetime_validator(cls, datetime_):
        if datetime_ == '':
            return datetime_

        else:
            try:
                date = datetime.datetime.strptime(datetime_, "%Y-%m-%dT%H:%M:%SZ")
                return (datetime.datetime.strftime(date, "%Y-%m-%dT%H:%M:%SZ"))

            except ValueError:
                raise ValueError('datetime_ format is wrong. It should be: %Y-%m-%dT%H:%M:%SZ')
    

    @validator('id')
    def not_null_id(cls, id):
        if id == '':
            raise ValueError("id can't be null!")
        return id