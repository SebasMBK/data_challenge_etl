from pydantic import BaseModel, validator
import datetime

# In this file, lies the code for the data validation to ensure the righ quality before the ingestion.

class jobs(BaseModel):
    """
    Pydantic model to validate the data.
    """
    id: int
    job: str

    @validator('id')
    def not_null_id(cls, id):
        if id == '':
            raise ValueError("id can't be null!")
        return id

    @validator('job')
    def not_null_job(cls, job):
        if job == '':
            raise ValueError("The job name can't be null!")
        return job