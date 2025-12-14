public class Camera {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    Transform transform;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform = new Transform();
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        float AR =  w/h;
        
        // TODO HW3
        // This function takes four parameters, which are 
        // the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.        
        float k =  tan(GH_FOV);
        
        projection.m[0] = 1;             projection.m[1] = 0;      projection.m[2] =  0;             projection.m[3] = 0; 
        projection.m[4] = 0;             projection.m[5] = AR;    projection.m[6] = 0;              projection.m[7] = 0;
        projection.m[8] = 0;             projection.m[9] = 0;      projection.m[10] = f/(f-n) * k;  projection.m[11] = (f*n)/(f-n) * k;
        projection.m[12] = 0;            projection.m[13] = 0;     projection.m[14] = k;            projection.m[15] = 0;
        

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {
      
    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.
        // so its just building a basis
        Vector3 world_top = new Vector3(0,1,0);
        Vector3 forward = lookat.sub(pos);//z
        Vector3 v3 = lookat.sub(pos);
        Vector3 v1 = Vector3.cross(world_top,  v3);
        Vector3 v2  = Vector3.cross(v3,v1);
        v1.normalize();
        v2.normalize();
        v3.normalize(); 
        Matrix4 view = new Matrix4();
        view.m[0] =  -v1.x;  view.m[1] = -v1.y;    view.m[2] = -v1.z;        view.m[3] =  Vector3.dot(pos,v1);
        view.m[4] =  v2.x;   view.m[5] = v2.y;      view.m[6] = v2.z;        view.m[7] =  -Vector3.dot(pos,v2);
        view.m[8] =  v3.x;   view.m[9] = v3.y;      view.m[10] = v3.z;       view.m[11] = -Vector3.dot(pos,v3);
        view.m[12] = 0;      view.m[13] = 0;        view.m[14] = 0;          view.m[15] = 1; 
        
        worldView = view;
    }
}
