USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjactsum_ssuma]    Script Date: 12/21/2015 15:43:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjactsum_ssuma]
@parm1 varchar (4) , @parm2 varchar (16)  , @parm3 varchar (32) , @parm4 varchar (2) , @parm5 varchar (1)  as
select SUM ( pjactsum.amount_bf ),
SUM ( pjactsum.amount_01 ),
SUM ( pjactsum.amount_02 ),
SUM ( pjactsum.amount_03 ),
SUM ( pjactsum.amount_04 ),
SUM ( pjactsum.amount_05 ),
SUM ( pjactsum.amount_06 ),
SUM ( pjactsum.amount_07 ),
SUM ( pjactsum.amount_08 ),
SUM ( pjactsum.amount_09 ),
SUM ( pjactsum.amount_10 ),
SUM ( pjactsum.amount_11 ),
SUM ( pjactsum.amount_12 ),
SUM ( pjactsum.amount_13 ),
SUM ( pjactsum.amount_14 ),
SUM ( pjactsum.amount_15 ),
SUM ( pjactsum.units_bf ),
SUM ( pjactsum.units_01 ),
SUM ( pjactsum.units_02 ),
SUM ( pjactsum.units_03 ),
SUM ( pjactsum.units_04 ),
SUM ( pjactsum.units_05 ),
SUM ( pjactsum.units_06 ),
SUM ( pjactsum.units_07 ),
SUM ( pjactsum.units_08 ),
SUM ( pjactsum.units_09 ),
SUM ( pjactsum.units_10 ),
SUM ( pjactsum.units_11 ),
SUM ( pjactsum.units_12 ),
SUM ( pjactsum.units_13 ),
SUM ( pjactsum.units_14 ),
SUM ( pjactsum.units_15 )
from pjactsum, pjacct
where pjactsum.fsyear_num = @parm1 and
pjactsum.project = @parm2 and
pjactsum.pjt_entity = @parm3 and
pjactsum.acct =  pjacct.acct  and
pjacct.acct_type like @parm4 and
pjacct.id3_sw like @parm5
GO
