USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CustCont_Name]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[CustCont_Name] @parm1 Varchar(10), @parm2 Varchar(15) as
       Select Name from CustContact where ContactID = @Parm1 and custid = @parm2
GO
