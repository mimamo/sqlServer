USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Terms_ApplyTo]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Terms_ApplyTo    Script Date: 4/7/98 12:42:26 PM ******/
Create Procedure [dbo].[Terms_ApplyTo]
@parm1 varchar (1), @parm2 varchar (2) as
       Select * from Terms
            Where ApplyTo IN (@parm1,'B')
            and   TermsID   LIKE @parm2
       Order by TermsID
GO
