USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[StkUnit_Global_Class]    Script Date: 12/21/2015 15:55:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[StkUnit_Global_Class]
	@Parm1 as Varchar(6),
        @Parm2 as VarChar(6)

As

select distinct tounit
from inunit
where ((UnitType = '2' and ClassID = @Parm1)
     Or(UnitType = '1'))
  and ToUnit Like @Parm2
order by toUnit
GO
