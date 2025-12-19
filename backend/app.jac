"""
MindMate Harmony Space - Main Application Entry Point
Initializes the graph, creates the mindmate_graph, and sets up walkers
"""

# Import all graph definitions and walkers
import:jac from "./mindmate.jac" as mindmate_graph;
import:jac from "./walkers.jac" as walkers;
import:jac from "./agents.jac" as agents;

# Entry point - Initialize the application
with entry {
    """
    Main entry point for MindMate Harmony Space
    Initializes the graph and makes it ready for use
    """
    
    # Create the main graph
    graph = spawn mindmate_graph();
    
    report {
        "status": "initialized",
        "graph": "mindmate_graph",
        "message": "MindMate Harmony Space is ready!",
        "timestamp": std.datetime.now().isoformat()
    };
}
