USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xJADeleteTemplate_IWT]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xJADeleteTemplate_IWT] 
  @TemplateHdrKey int
AS
BEGIN
  SET NOCOUNT ON

  -- Delete the Detail Records
  DELETE FROM
    xJATemplateDtl_IWT
  WHERE
    TemplateHdrKey = @TemplateHdrKey 
    
  -- Delete the Header Records
  DELETE FROM
    xJATemplateHdr_IWT
  WHERE
    TemplateHdrKey = @TemplateHdrKey 
    
END
GO
