USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkSUTAD_DEL_UserId]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkSUTAD_DEL_UserId] @parm1 varchar ( 47) as
       Delete wrksutad from WrkSUTAD
           where UserId   =  @parm1
GO
