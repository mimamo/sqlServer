USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Terms_No_Installment]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Terms_No_Installment    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[Terms_No_Installment] @parm1 varchar ( 1), @parm2 varchar(2) as
    Select * from Terms where  ApplyTo IN (@parm1,'B') and TermsType <> 'M' and TermsId like @parm2  order by TermsId
GO
