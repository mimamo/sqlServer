USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEmployee_EmpID]    Script Date: 12/21/2015 15:49:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDEmployee_EmpID]
  @EmpID      varchar(10)
AS
  Select      *
  FROM        Employee
  WHERE       EmpID LIKE @EmpID
GO
