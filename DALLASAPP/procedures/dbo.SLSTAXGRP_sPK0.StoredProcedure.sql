USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SLSTAXGRP_sPK0]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[SLSTAXGRP_sPK0] @parm1 varchar (10)   as
select * from SLSTAXGRP
where GroupID =  @parm1
order by GroupID, TaxID
GO
