USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_DocClass_RefNbr_Cpny]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_DocClass_RefNbr_Cpny    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_DocClass_RefNbr_Cpny] @parm1 varchar (10), @parm2 varchar ( 1), @parm3 varchar ( 10) as
Select *
  FROM APDoc
 WHERE cpnyid = @parm1
   AND DocClass = @parm2
   AND RefNbr LIKE @parm3
   AND DocType <> 'VT'
 ORDER BY  DocClass Desc, RefNbr
GO
