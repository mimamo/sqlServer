USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Record_RecordName]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Record_RecordName    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.Record_RecordName    Script Date: 4/7/98 12:51:20 PM ******/
Create Proc  [dbo].[Record_RecordName] @parm1 varchar ( 20) as
       Select * from Record
           where RecordName  LIKE  @parm1
           order by RecordName
GO
