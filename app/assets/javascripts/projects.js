var Project = {

  taskFromAnchor: function(anchor_element) { 
    return anchor_element.parents("tr");
  },

  previousTask: function(task_row) { 
    result = task_row.prev(); 
    if(result.length > 0) {
      return result; } 
    else {
      return null; 
    }
  },

  swapRows: function(first_row, second_row) { 
    second_row.detach(); 
    second_row.insertBefore(first_row);
  },

  upClickOn: function(anchor_element) {
      row = Project.taskFromAnchor(anchor_element);
      previousRow = Project.previousTask(row);
      if(previousRow == null) { return };
      Project.swapRows(previousRow, row);
    } 
}

$(function() {
  $(document).on("click", ".up", function(event) {
    event.preventDefault();
    Project.upClickOn($(this));
  });
})