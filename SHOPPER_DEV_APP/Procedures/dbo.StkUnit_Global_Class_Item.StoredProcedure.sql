USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[StkUnit_Global_Class_Item]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[StkUnit_Global_Class_Item]
	@Parm1 as Varchar(30),
        @Parm2 as Varchar(6),
        @Parm3 as VarChar(6)

As

select distinct tounit
from inunit
where ((UnitType = '3' and invtid =  @Parm1)
     Or(UnitType = '2' and ClassID = @Parm2)
     Or(UnitType = '1'))
  and ToUnit Like @Parm3
order by toUnit
GO
