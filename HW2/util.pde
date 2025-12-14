public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // Please paste your code from HW1 CGLine.
    // TODO HW1
    // You need to implement the "line algorithm" in this section.
    // You can use the function line(x1, y1, x2, y2); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // For instance: drawPoint(114, 514, color(255, 0, 0)); signifies drawing a red
    // point at (114, 514).
    // Note that we will be dealing with octants
    int dx = (int)abs(x2 - x1); 
    int dy = (int)abs(y2 -y1);
    int sx = x2 > x1 ? 1 : -1; // deal with  
    int sy = y2 > y1 ? 1 : -1;
    
    //decide the octant (0 - 45)
    int x = round(x1), y = round(y1);
    if (dx > dy) { // x is driving axis
    int d = 2*dy - dx; // Bresenham's decision variable
      for (int i = 0; i <= dx; i++) {
            drawPoint(x, y, color(0,0,0));
            if (d > 0) {
                y += sy;
                d -= 2*dx;
            }
            d += 2*dy;
            x += sx;
        }
    } else { // y is driving axis
        int d = 2*dx - dy;
        for (int i = 0; i <= dy; i++) {
            drawPoint(x, y, color(0,0,0));
            if (d > 0) {
                x += sx;
                d -= 2*dy;
            }
            d += 2*dx;
            y += sy;
        }
}
}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2 
    // You need to check the coordinate p(x,v) if inside the vertices. 
    // If yes return true, vice versa.
    int count = 0;
    int n = vertexes.length;
    for(int i = 0; i< n;  i++){
        Vector3 p1, p2;
        p1  =  vertexes[i];
        p2 = vertexes[(i+1)%n];
        if((y<  p1.y) != (y<p2.y)){
          float decision = ( (y - p1.y) * (p2.x - p1.x) ) / (p2.y - p1.y) + p1.x;
          if(x  < decision){
            count ++;
          }
        }
        
    }

    return count%2 ==1;
}

public Vector3[] findBoundBox(Vector3[] v) {
    
    
    // TODO HW2 
    // You need to find the bounding box of the vertices v.
    // r1 -------
    //   |   /\  |
    //   |  /  \ |
    //   | /____\|
    //    ------- r2

    Vector3 recordminV = new Vector3(0);
    Vector3 recordmaxV = new Vector3(999);
    float minX, minY, minZ;
    float maxX, maxY, maxZ;
    minX = minY = minZ = Float.MAX_VALUE;
    maxX = maxY = maxZ  = Float.MIN_VALUE;
    for(Vector3 vec : v){
      minX = min(vec.x, minX);
      minY = min(vec.y, minY);
      minZ = min(vec.z,  minZ);
      maxX = max(vec.x, maxX);
      maxY = max(vec.y, maxY);
      maxZ = max(vec.z, maxZ);
      
    }
    
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}
public boolean inside(Vector3 p, Vector3 a, Vector3 b) {
    return (b.x - a.x)*(p.y - a.y) - (b.y - a.y)*(p.x - a.x) <= 0;
}
Vector3 intersection(Vector3 p, Vector3 q, Vector3 a, Vector3 b) {
    float A1 = q.y - p.y;
    float B1 = p.x - q.x;
    float C1 = A1 * p.x + B1 * p.y;

    float A2 = b.y - a.y;
    float B2 = a.x - b.x;
    float C2 = A2 * a.x + B2 * a.y;

    float det = A1 * B2 - A2 * B1;
    if (Math.abs(det) < 1e-6) {
        return p; // Lines are parallel, return one point arbitrarily
    }

    float x = (B2 * C1 - B1 * C2) / det;
    float y = (A1 * C2 - A2 * C1) / det;

    return new Vector3(x, y, 0);
}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }
    
    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertices of the "boundary".
    // The output is the vertices of the polygon.
    int n  = points.length;
    int bn = boundary.length;
    for(int i = 0; i< bn; i++){
      Vector3 b1 = boundary[i];
      Vector3 b2 = boundary[(i+1)%bn];
      output.clear();
      n = input.size();
      for(int j =0; j< n;j++){
          Vector3 p1 = input.get(j);
          Vector3 p2 = input.get((j+1)%n);
          boolean p1Inside = inside(p1,  b1, b2);
          boolean p2Inside = inside(p2, b1, b2);
          if(p1Inside&& p2Inside){
            output.add(p2);
            
          }
          else if(p1Inside && !p2Inside){
            Vector3 inter = intersection(p1,p2,b1, b2);
            output.add(inter);
          }
          else if(!p1Inside && p2Inside){
            Vector3 inter = intersection(p1,p2,b1, b2);
            output.add(inter);
            output.add(p2);
          }
        
        
      }
      input = new ArrayList<Vector3>(output);
    }
    output = input;
    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    
    return result;
}
