# distutils: language = c++
from libcpp.vector cimport vector
from libcpp cimport bool


cdef extern from "Vector2.h" namespace "AVO":
    cdef cppclass Vector2:
        Vector2() except +
        Vector2(float x_, float y_) except +
        float x_ const
        float y_ const

cdef extern from "Line.h" namespace "AVO":
    cdef cppclass Line:
        Vector2 point
        Vector2 direction


cdef extern from "Simulator.h" namespace "AVO":
    cdef cppclass Simulator:
        Simulator()
        size_t addAgent(const Vector2 &position, float neighborDist,
                                size_t maxNeighbors, float timeHorizon,
                                float radius, float maxSpeed, float maxAccel,
                                float accelInterval)
        size_t addAgent(const Vector2 &position, float neighborDist,
                                size_t maxNeighbors, float timeHorizon,
                                float radius, float maxSpeed, float maxAccel,
                                float accelInterval, const Vector2 &velocity)
        void doStep() nogil
        size_t getAgentNeighbor(size_t agentNo, size_t neighborNo) const
        float getAgentMaxAccel(size_t agentNo) const
        size_t getAgentMaxNeighbors(size_t agentNo) const
        float getAgentMaxSpeed(size_t agentNo) const
        float getAgentNeighborDist(size_t agentNo) const
        size_t getAgentNumNeighbors(size_t agentNo) const
        size_t getAgentNumOrcaLines(size_t agentNo) const
        const Line & getAgentOrcaLine(size_t agentNo, size_t lineNo) const
        const Vector2 & getAgentPosition(size_t agentNo) const
        const Vector2 & getAgentPrefVelocity(size_t agentNo) const
        float getAgentRadius(size_t agentNo) const
        float getAgentTimeHorizon(size_t agentNo) const
        const Vector2 & getAgentVelocity(size_t agentNo) const
        void setAgentAccelInterval(size_t agentNo, float accelInterval)
        void setAgentDefaults(float neighborDist, size_t maxNeighbors,
                              float timeHorizon, float radius,
                              float maxSpeed, float maxAccel,
                              float accelInterval)
        void setAgentDefaults(float neighborDist, size_t maxNeighbors,
                              float timeHorizon, float radius,
                              float maxSpeed, float maxAccel,
                              float accelInterval, const Vector2 &velocity)
        void setAgentMaxAccel(size_t agentNo, float maxAccel)
        void setAgentMaxNeighbors(size_t agentNo, size_t maxNeighbors)
        void setAgentMaxSpeed(size_t agentNo, float maxSpeed)
        void setAgentNeighborDist(size_t agentNo, float neighborDist)
        void setAgentPosition(size_t agentNo, const Vector2 & position)
        void setAgentPrefVelocity(size_t agentNo, const Vector2 & prefVelocity)
        void setAgentRadius(size_t agentNo, float radius)
        void setAgentTimeHorizon(size_t agentNo, float timeHorizon)
        void setAgentVelocity(size_t agentNo, const Vector2 & velocity)
        void setGlobalTime(float globalTime)
        void setTimeStep(float timeStep)

cdef class PyAVOSimulator:
    cdef Simulator *thisptr

    def __cinit__(self):
        self.thisptr = new Simulator()

    def addAgent(self, tuple pos, float neighborDist, size_t maxNeighbors, float timeHorizon, 
                 float radius, float maxSpeed, float maxAccel, float accelInterval, velocity=None):
        cdef Vector2 c_pos = Vector2(pos[0], pos[1])
        cdef Vector2 c_velocity

        if velocity is None:
            agent_nr = self.thisptr.addAgent(c_pos, neighborDist, maxNeighbors, timeHorizon, radius, maxSpeed, maxAccel, accelInterval)
        else:
            c_velocity = Vector2(velocity[0], velocity[1])
            agent_nr = self.thisptr.addAgent(c_pos, neighborDist, maxNeighbors, timeHorizon, radius, maxSpeed, maxAccel, accelInterval, c_velocity)
        return agent_nr

    def doStep(self):
        with nogil:
            self.thisptr.doStep()

    def getAgentNeighbor(self, size_t agent_no, size_t neighbor_no):
        return self.thisptr.getAgentNeighbor(agent_no, neighbor_no)
    def getAgentMaxAccel(self, size_t agent_no):
        return self.thisptr.getAgentMaxAccel(agent_no) 
    def getAgentMaxNeighbors(self, size_t agent_no):
        return self.thisptr.getAgentMaxNeighbors(agent_no)
    def getAgentMaxSpeed(self, size_t agent_no):
        return self.thisptr.getAgentMaxSpeed(agent_no)
    def getAgentNeighborDist(self, size_t agent_no):
        return self.thisptr.getAgentNeighborDist(agent_no)
    def getAgentNumNeighbors(self, size_t agent_no):
        return self.thisptr.getAgentNumNeighbors(agent_no)
    def getAgentNumOrcaLines(self, size_t agent_no):
        return self.thisptr.getAgentNumOrcaLines(agent_no)
    def getAgentOrcaLine(self, size_t agent_no, size_t line_no):
        cdef Line line = self.thisptr.getAgentOrcaLine(agent_no, line_no)
        return line.point.x_, line.point.y_, line.direction.x_, line.direction.y_
    def getAgentPosition(self, size_t agent_no):
        cdef Vector2 pos = self.thisptr.getAgentPosition(agent_no)
        return pos.x_, pos.y_
    def getAgentPrefVelocity(self, size_t agent_no):
        cdef Vector2 velocity = self.thisptr.getAgentPrefVelocity(agent_no)
        return velocity.x_, velocity.y_
    def getAgentRadius(self, size_t agent_no):
        return self.thisptr.getAgentRadius(agent_no)
    def getAgentTimeHorizon(self, size_t agent_no):
        return self.thisptr.getAgentTimeHorizon(agent_no)
    def getAgentVelocity(self, size_t agent_no):
        cdef Vector2 velocity = self.thisptr.getAgentVelocity(agent_no)
        return velocity.x_, velocity.y_
    def setAgentAccelInterval(self, size_t agent_no, float accel_interval):
        self.thisptr.setAgentAccelInterval(agent_no, accel_interval)
    def setAgentDefaults(self, float neighbor_dist, size_t max_neighbors, float time_horizon,
                         float radius, float max_speed, float max_accel, float accel_interval,
                         velocity = None):
        cdef Vector2 c_velocity
        if velocity is not None:
            c_velocity = Vector2(velocity[0], velocity[1])
            self.thisptr.setAgentDefaults(neighbor_dist, max_neighbors, time_horizon,
                                      radius, max_speed, max_accel, accel_interval, c_velocity)
        else:
            self.thisptr.setAgentDefaults(neighbor_dist, max_neighbors, time_horizon,
                                      radius, max_speed, max_accel, accel_interval)
    
    def setAgentMaxAccel(self, size_t agent_no, float max_accel):
        self.thisptr.setAgentAccelInterval(agent_no, max_accel)
    def setAgentMaxNeighbors(self, size_t agent_no, size_t max_neighbors):
        self.thisptr.setAgentMaxNeighbors(agent_no, max_neighbors)
    def setAgentMaxSpeed(self, size_t agent_no, float max_speed):
        self.thisptr.setAgentMaxSpeed(agent_no, max_speed)
    def setAgentNeighborDist(self, size_t agent_no, float neighbor_dist):
        self.thisptr.setAgentNeighborDist(agent_no, neighbor_dist)
    def setAgentPosition(self, size_t agent_no, tuple position):
        cdef Vector2 c_pos = Vector2(position[0], position[1])
        self.thisptr.setAgentPosition(agent_no, c_pos)
    def setAgentPrefVelocity(self, size_t agent_no, tuple velocity):
        cdef Vector2 c_velocity = Vector2(velocity[0], velocity[1])
        self.thisptr.setAgentPrefVelocity(agent_no, c_velocity)
    def setAgentRadius(self, size_t agent_no, float radius):
        self.thisptr.setAgentRadius(agent_no, radius)
    def setAgentTimeHorizon(self, size_t agent_no, float time_horizon):
        self.thisptr.setAgentTimeHorizon(agent_no, time_horizon)
    def setAgentVelocity(self, size_t agent_no, tuple velocity):
        cdef Vector2 c_velocity = Vector2(velocity[0], velocity[1])
        self.thisptr.setAgentVelocity(agent_no, c_velocity)
    def setGlobalTime(self, float global_time):
        self.thisptr.setGlobalTime(global_time)
    def setTimeStep(self, float time_step):
        self.thisptr.setTimeStep(time_step)
    def setAgentCollabCoeff(self, size_t agent_no, float collab_coeff):
        pass
    def getAgentCollabCoeff(self, size_t agent_no):
        pass