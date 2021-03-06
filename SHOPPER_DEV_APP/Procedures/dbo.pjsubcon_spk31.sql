USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjsubcon_spk31]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjsubcon_spk31] @parm1 varchar (10) , @parm2 varchar (15) , @parm3 varchar (1) , @parm4 varchar (4) , @parm5 varchar (16) ,
@parm6 varchar (16) , @parm7 varchar (16) , @parm8 varchar (16) , @parm9 varchar (16) , @parm10 varchar (16) , @parm11 varchar (16)  as
select * from pjsubcon, pjproj
where    pjsubcon.project          =    pjproj.project
and      pjproj.manager1           like @parm1
and      pjsubcon.vendid           like @parm2
and      pjsubcon.status_sub       like @parm3
and      pjsubcon.su_id15          =    @parm4
and      pjsubcon.project          like @parm5
and      (pjsubcon.subcontract     like @parm6  or
pjsubcon.subcontract     like @parm7  or
pjsubcon.subcontract     like @parm8  or
pjsubcon.subcontract     like @parm9  or
pjsubcon.subcontract     like @parm10 or
pjsubcon.subcontract     like @parm11
)
GO
