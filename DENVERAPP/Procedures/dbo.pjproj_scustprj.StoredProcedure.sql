USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjproj_scustprj]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[pjproj_scustprj] @parm1 varchar (15) , @parm2 varchar (16),  @parm3 varchar (10)   as
select * from pjproj
where customer like @parm1
and project like @parm2
and cpnyid = @parm3
and (contract_type = 'FPR' OR
contract_type = 'FPW' OR
contract_type = 'TMR' OR
contract_type = 'TMW' OR
contract_type = 'CPR' OR
contract_type = 'CPW')
GO
