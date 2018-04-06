function [endmemberindex duration] = OBA(imageSerialized,k)

  [bands, numPix] = size(imageSerialized)

  tic;

  %===========================================
  % OBTAIN THE BRIGHTER PIXEL
  %===========================================
  tmpMaxH                 = 0;
  tmpPos                  = -1;
  for i=1:numPix
      hi                  = norm(imageSerialized(:,i));
      if(hi>tmpMaxH)
          tmpMaxH         = hi;
          tmpPos          = i;
      end
  end
  clear('hypImg');

  %===========================================
  % BACKUP FIRST ENDMEBERS e0
  %===========================================
  lstExtracted            = ones(1,numPix);
  endmemberindex          = zeros(1,k);
  endmemberindex(1)       = tmpPos;
  lstExtracted(tmpPos)    = 0;
  j=1;

  %===========================================
  % SEARCH e1
  %===========================================
  tmpMaxH                 = 0;
  tmpPos                  = -1;
  for i=1:numPix
      if(lstExtracted(i)==1)
          hi              = norm(imageSerialized(:,i) - imageSerialized(:,endmemberindex(1)) );
          if(hi>tmpMaxH)
              tmpMaxH     = hi;
              tmpPos      = i;
          end
      end
  end
  endmemberindex(2)       = tmpPos;
  lstExtracted(tmpPos)    = 0;

  %===========================================
  % CALCULATE alpha, Beta, l and Y
  %===========================================
  l                       = zeros(bands,numPix);
  Y                       = zeros(bands,numPix);
  alpha                   = imageSerialized(:,endmemberindex(2)) - imageSerialized(:,endmemberindex(1));
  Beta                    = alpha;
  for i=1:numPix
      l(:,i)              = imageSerialized(:,i) - imageSerialized(:,endmemberindex(1));
      Y(:,i)              = l(:,i) - ( ( ( l(:,i)' * Beta ) / ( Beta' * Beta ) ) * Beta );
  end

  %===========================================
  % EXTRACT THE OTHERS
  %===========================================
  for j=3:k    
      tmpMaxH             = 0;
      tmpPos              = -1;
      for i=1:numPix
          if(lstExtracted(i)==1)
              tmpLen = norm(Y(:,i));
              if( tmpLen  > tmpMaxH )
                  tmpMaxH     = tmpLen;
                  tmpPos      = i;
              end
          end
      end
      endmemberindex(j)       = tmpPos;
      lstExtracted(tmpPos)    = 0;
      % Update Beta
      Beta                    = Y(:,tmpPos);
      % Update Yota
      for i=1:numPix
          Y(:,i)              = l(:,i) - ( ( ( l(:,i)' * Beta ) / ( Beta' * Beta ) ) * Beta );
      end
  end
  
  duration  = toc;

endfunction





