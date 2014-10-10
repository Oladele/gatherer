describe("with a list of tasks", function() {
  beforeEach(function() {
    table = affix("table");
    table.affix("tr.task#task_1 a.up");
    table.affix("tr.task#task_2 a.up+a.down");
    table.affix("tr.task#task_3 a.up");
  });

  it("correctly processes an up click", function() {
    $("#task_2 .up").click();
    expect($.map($("tr"), function(item) { 
      return $(item).attr("id") 
    })).toEqual(["task_2", "task_1", "task_3"]); 
  });
});

