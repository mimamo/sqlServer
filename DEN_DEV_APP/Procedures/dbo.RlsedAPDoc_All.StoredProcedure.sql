USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RlsedAPDoc_All]    Script Date: 12/21/2015 14:06:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RlsedAPDoc_All    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[RlsedAPDoc_All] As
Select * From APDoc Where
Rlsed = 1 and
VendId <> '' and
(DocType Not In ('VT', 'MC', 'SC', 'ZC') and DocType Not Like 'B%')
and DocClass <> 'R'
Order By VendId, PerPost
GO
