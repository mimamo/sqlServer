USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk2]    Script Date: 12/21/2015 15:43:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk2] @parm1 varchar (16)  as
select * from pjinvhdr where
project_billwith = @parm1 AND
inv_status <>  'PO'
order by draft_num Desc
GO
