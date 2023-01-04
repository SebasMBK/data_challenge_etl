from pydantic import BaseModel, validator

# In this file, lies the code for the data validation to ensure the righ quality before the ingestion.

class departments(BaseModel):
    """
    Pydantic model to validate the data.
    """
    id: int
    department: str


    @validator('id')
    def not_null_id(cls, id):
        if id == '':
            raise ValueError("id can't be null!")
        return id

    @validator('department')
    def not_null_department(cls, department):
        if department == '':
            raise ValueError("The department name can't be null!")
        return department