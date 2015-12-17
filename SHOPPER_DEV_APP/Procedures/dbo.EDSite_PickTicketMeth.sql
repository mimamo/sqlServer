USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSite_PickTicketMeth]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSite_PickTicketMeth] @SiteId as varchar(10)  AS
-- Returns ConvMeth for Site
Declare @RetVal VarChar(10)
select @RetVal = (Select ConvMeth  from EDSite where SiteId = @SiteId and Trans = '940')
-- If not set up, assume print only
if IsNull(@RetVal,'~') = '~'
   Select @RetVal = 'PPT'
Select @RetVal
GO
