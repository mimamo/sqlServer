USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPROJ_sPK11]    Script Date: 12/21/2015 16:07:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPROJ_sPK11] @parm1 varchar (16)  as
select * from PJPROJ
where project = @parm1
and (contract_type = 'FPR' OR
contract_type = 'FPW' OR
contract_type = 'TMR' OR
contract_type = 'TMW' OR
contract_type = 'CPR' OR
contract_type = 'CPW')
order by project
GO
