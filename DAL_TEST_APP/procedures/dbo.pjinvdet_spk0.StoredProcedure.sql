USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk0]    Script Date: 12/21/2015 13:57:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk0] @parm1 int  as
select * from
pjinvdet
Where
source_trx_id = @parm1
order by
source_trx_id
GO
