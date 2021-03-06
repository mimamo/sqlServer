USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARAdjust_Bat_CustId_AdjgType]    Script Date: 12/21/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARAdjust_Bat_CustId_AdjgType    Script Date: 4/7/98 12:30:32 PM ******/
Create Proc [dbo].[ARAdjust_Bat_CustId_AdjgType] @parm1 varchar ( 10), @parm2 varchar (15),  @parm3 varchar ( 10), @parm4 varchar ( 10) as
    Select * from ARAdjust where AdjBatnbr = @parm1
          and CustId = @parm2
           and AdjgDocType IN ('RP', 'NS')
           and AdjgRefNbr = @parm3
           and AdjdRefnbr = @parm4
           order by CustId, AdjgDocType,AdjgRefNbr
GO
