USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Record_Module_RecordName]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Record_Module_RecordName    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.Record_Module_RecordName    Script Date: 4/7/98 12:51:20 PM ******/
Create Proc  [dbo].[Record_Module_RecordName] @parm1 varchar ( 2), @parm2 varchar ( 20) as
       Select * from Record
           where Module      LIKE  @parm1
             and RecordName  LIKE  @parm2
           order by Module, RecordName
GO
