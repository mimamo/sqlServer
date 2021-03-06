USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Terms_ApplyTo_NoDiscount]    Script Date: 12/21/2015 13:57:17 ******/
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
