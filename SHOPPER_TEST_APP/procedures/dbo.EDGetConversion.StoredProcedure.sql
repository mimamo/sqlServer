USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDGetConversion]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDGetConversion] @Unit1 varchar(6), @Unit2 varchar(6), @InvtId varchar(30), @ClassId varchar(6) As
If LTrim(RTrim(@Unit1)) <> LTrim(RTrim(@Unit2))
  Select FromUnit, ToUnit, CnvFact, MultDiv From InUnit Where FromUnit In (@Unit1, @Unit2) And ToUnit In (@Unit1, @Unit2)
  And InvtId In (@InvtId, '*') And ClassId In (@ClassId, '*') And FromUnit <> ToUnit
  Order By UnitType Desc
Else
  Select FromUnit, ToUnit, CnvFact, MultDiv From InUnit Where FromUnit In (@Unit1, @Unit2) And ToUnit In (@Unit1, @Unit2)
  And InvtId In (@InvtId, '*') And ClassId In (@ClassId, '*')
  Order By UnitType Desc
GO
