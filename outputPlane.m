function [ plane ] = outputPlane( p1,p2,p3 )
% outputs the plane in form [a,b,c,d] where eq is ax+by+cz+d = 0
normal = cross(p1-p2,p1-p3);
normal = normal./norm(normal);
soln = normal(1)*p1(1) + normal(2)*p1(2) + normal(3)*p1(3);
plane = [normal,soln];
end

