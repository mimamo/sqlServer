USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Terms_ApplyTo_NoDiscount]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Terms_ApplyTo_NoDiscount    Script Date: 1/5/07  ******/
Create Procedure [dbo].[Terms_ApplyTo_NoDiscount]
@parm1 varchar (1), @parm2 varchar (2) as
       Select * from Terms
            Where ApplyTo IN (@parm1,'B')
	    and   DiscPct = '0'
            and   TermsID   LIKE @parm2
       Order by TermsID
GO
