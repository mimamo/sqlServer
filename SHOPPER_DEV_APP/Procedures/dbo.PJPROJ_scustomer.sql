USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_scustomer]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_scustomer] @parm1 varchar (15) , @parm2 varchar (16),  @parm3 varchar (10)  as
select * from PJPROJ
where customer = @parm1    and
project like @parm2  and
cpnyid = @parm3 and
(contract_type = 'FPR' OR
contract_type = 'FPW' OR
contract_type = 'TMR' OR
contract_type = 'TMW' OR
contract_type = 'CPR' OR
contract_type = 'CPW')
GO
