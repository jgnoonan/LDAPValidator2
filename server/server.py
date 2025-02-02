import grpc
from concurrent import futures
import ldap_validation_pb2
import ldap_validation_pb2_grpc
import os
import msal

class LDAPValidationService(ldap_validation_pb2_grpc.LdapValidationServiceServicer):
    def ValidateCredentials(self, request, context):
        try:
            response = ldap_validation_pb2.ValidateCredentialsResponse()
            
            # Mock validation based on credentials
            if request.user_id == "test" and request.password == "test":
                response.result.phone_number = "+1234567890"
            else:
                error = ldap_validation_pb2.ValidateCredentialsError()
                error.error_type = ldap_validation_pb2.VALIDATE_CREDENTIALS_ERROR_TYPE_INVALID_CREDENTIALS
                error.message = "Invalid credentials"
                response.result.error.CopyFrom(error)
            return response
        except Exception as e:
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details(str(e))
            return ldap_validation_pb2.ValidateCredentialsResponse()

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    ldap_validation_pb2_grpc.add_LdapValidationServiceServicer_to_server(
        LDAPValidationService(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    print("Server started on port 50051")
    server.wait_for_termination()

if __name__ == '__main__':
    serve()
