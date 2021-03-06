USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjsubcon_spk2]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjsubcon_spk2] @parm1 varchar (10) , @parm2 varchar (15) , @parm3 varchar (1) , @parm4 varchar (4) , @parm5 varchar (16)  as
select * from pjsubcon, pjproj
where    pjsubcon.project          =    pjproj.project
and      pjproj.manager1           like @parm1
and      pjsubcon.vendid           like @parm2
and      pjsubcon.status_sub       like @parm3
and      pjsubcon.su_id15          =    @parm4
and      pjsubcon.project          like @parm5
order by
pjsubcon.project,
pjsubcon.subcontract
GO
