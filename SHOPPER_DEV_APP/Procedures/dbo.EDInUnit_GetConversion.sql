USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInUnit_GetConversion]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDInUnit_GetConversion] @FromUnit varchar(6), @ToUnit varchar(6), @InvtId varchar(30), @ClassId varchar(6) As
Select CnvFact, MultDiv From InUnit Where FromUnit = @FromUnit And ToUnit = @ToUnit And
InvtId In (@InvtId,'*') And ClassId In (@ClassId,'*') Order By UnitType Desc
GO
