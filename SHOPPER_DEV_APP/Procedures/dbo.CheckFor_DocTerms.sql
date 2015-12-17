USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CheckFor_DocTerms]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create procedure [dbo].[CheckFor_DocTerms] @parm1 varchar (10), @parm2 varchar(2) as
       Select *
         From Docterms
           Where Refnbr = @parm1
             and doctype = @parm2
GO
