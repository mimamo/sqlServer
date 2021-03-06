USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_CustId_AdjdType_Ref]    Script Date: 12/21/2015 13:35:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAdjust_CustId_AdjdType_Ref    Script Date: 4/7/98 12:30:32 PM ******/
Create Proc [dbo].[ARAdjust_CustId_AdjdType_Ref] @parm1 varchar ( 15), @parm2 varchar ( 2), @parm3 varchar ( 10) as
    Select * from ARAdjust where CustId like @parm1
           and AdjdDocType = @parm2
           and AdjdRefNbr = @parm3
           order by CustId, AdjdDocType, AdjdRefNbr, AdjgDocDate
GO
