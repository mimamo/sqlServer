USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PayGroup_PayGrpId]    Script Date: 12/21/2015 13:57:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PayGroup_PayGrpId] @parm1 varchar ( 6) as
       Select * from PayGroup
           where PayGrpId like @parm1
           order by PayGrpId
GO
