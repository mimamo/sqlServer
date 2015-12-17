USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBUDSUM_sCurrAmt]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBUDSUM_sCurrAmt] @parm1 varchar (4) , @parm2 varchar (16)  as
SELECT * from PJBUDSUM
WHERE
fsyear_num = @parm1 and
project =  @parm2 and
(amount_01 <> 0 or
amount_02 <> 0 or
amount_03 <> 0 or
amount_04 <> 0 or
amount_05 <> 0 or
amount_06 <> 0 or
amount_07 <> 0 or
amount_08 <> 0 or
amount_09 <> 0 or
amount_10 <> 0 or
amount_11 <> 0 or
amount_12 <> 0 or
amount_13 <> 0 or
amount_14 <> 0 or
amount_15 <> 0 or
units_01 <> 0 or
units_02 <> 0 or
units_03 <> 0 or
units_04 <> 0 or
units_05 <> 0 or
units_06 <> 0 or
units_07 <> 0 or
units_08 <> 0 or
units_09 <> 0 or
units_10 <> 0 or
units_11 <> 0 or
units_12 <> 0 or
units_13 <> 0 or
units_14 <> 0 or
units_15 <> 0)
GO
