USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[W2Empnam_EmpId]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[W2Empnam_EmpId] @parm1 varchar(10) as
       Select * from W2Empname
           where EmpId like @parm1
           order by EmpId
GO
