USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[GetInvcDate]    Script Date: 12/21/2015 13:44:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[GetInvcDate] @parm1 varchar (15), @parm2 varchar (10) as
 select min(docdate) from ardoc where custid = @parm1
and doctype = "IN"
and cpnyid like @parm2
GO
