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
      Project.ajaxCall(row.attr("id"), "up");
    },

  ajaxCall: function(domId, upOrDown) {
    taskId = domId.split("_")[1];
    
    $.ajax({
      url: "/tasks/" + taskId + "/" + upOrDown + ".js", 
      data: { "_method": "PATCH"},
      type: "POST"
    }).done(function(data) {
      Project.successfulUpdate(data)
    }).fail(function(data) {
      Project.failedUpdate(data);
    });

  },

  successfulUpdate: function(data) {},

  failedUpdate: function(data) {}
}

$(function() {
  $(document).on("click", ".up", function(event) {
    event.preventDefault();
    Project.upClickOn($(this));
  });
})