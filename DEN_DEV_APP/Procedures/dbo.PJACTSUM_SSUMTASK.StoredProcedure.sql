USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJACTSUM_SSUMTASK]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACTSUM_SSUMTASK] @parm1 varchar (4) , @parm2 varchar (16) , @parm3 varchar (32) , @parm4 varchar (16)  as
select SUM (amount_bf ),
SUM (amount_01 ),
SUM (amount_02 ),
SUM (amount_03 ),
SUM (amount_04 ),
SUM (amount_05 ),
SUM (amount_06 ),
SUM (amount_07 ),
SUM (amount_08 ),
SUM (amount_09 ),
SUM (amount_10 ),
SUM (amount_11 ),
SUM (amount_12 ),
SUM (amount_13 ),
SUM (amount_14 ),
SUM (amount_15 ),
SUM (units_bf ),
SUM (units_01 ),
SUM (units_02 ),
SUM (units_03 ),
SUM (units_04 ),
SUM (units_05 ),
SUM (units_06 ),
SUM (units_07 ),
SUM (units_08 ),
SUM (units_09 ),
SUM (units_10 ),
SUM (units_11 ),
SUM (units_12 ),
SUM (units_13 ),
SUM (units_14 ),
SUM (units_15 )
from PJACTSUM
where    fsyear_num = @parm1
and   project    = @parm2
and   pjt_entity like @parm3
and   acct       = @parm4
group by fsyear_num,
project,
substring(pjt_entity, 1, charindex('%', @parm3) - 1),
acct
order by fsyear_num,
project,
substring(pjt_entity, 1, charindex('%', @parm3) - 1),
acct
GO
